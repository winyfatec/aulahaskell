{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Login where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius
import Yesod
import Yesod.Form.Bootstrap3


formLogin :: Form (Text,Text)
formLogin  = renderBootstrap $ (,)
    <$> areq textField nomeUsuario Nothing
    <*> areq passwordField (bfs ("Senha" :: Text)) Nothing
    -- <*  bootstrapSubmit ("Logar" :: BootstrapSubmit Text)
    where nomeUsuario = withAutofocus $ withPlaceholder "Nome de usuário..." $ (bfs ("Nome de Usuário" :: Text))

getLoginR :: Handler Html
getLoginR = do
    (widget,enctype) <- generateFormPost formLogin
    defaultLayout $ do
        msg <- getMessage
        setTitle "Aula Haskell Fatec :: Login"
        addStylesheet $ StaticR css_main_css
        addScript $ StaticR js_main_js
        toWidgetHead [hamlet|
            <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
        |]
        $(whamletFile "templates/login.hamlet")
        $(whamletFile "templates/footer.hamlet")

   
postLoginR :: Handler Html
postLoginR = do
    ((result,_),_) <- runFormPost formLogin
    case result of
        FormSuccess ("root@root.com","root") -> do
            setSession "_NOME" "root"
            redirect HomeR
        FormSuccess (username,senha) -> do
            usuario <- runDB $ getBy (UniqueUsername username)
            case usuario of
                Nothing -> do
                    setMessage[shamlet|
                        <div>
                            Usuario nao encntrado
                    |]
                    redirect LoginR
                Just(Entity uid usr) -> do
                    if(userPassword usr == senha) then do
                        setSession "_NOME" (userUsername usr)
                        redirect HomeR
                    else do
                        setMessage[shamlet|
                            <div>
                                Senha invalida
                        |]
                        redirect LoginR
        _ -> redirect IndexR

postLogoutR :: Handler Html
postLogoutR = do
    deleteSession "_NOME"
    redirect IndexR