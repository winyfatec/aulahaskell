{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.UserLogin where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius
import Yesod
import Yesod.Form.Bootstrap3


formUserLogin :: Form (Text,Text)
formUserLogin  = renderBootstrap $ (,)
    <$> areq textField "Nome de usuario: " Nothing
    <*> areq passwordField "Senha" Nothing
    <*  bootstrapSubmit ("Logar" :: BootstrapSubmit Text)


getUserLoginR :: Handler Html
getUserLoginR = do
    (widget,enctype) <- generateFormPost $ renderBootstrap3 BootstrapBasicForm formUserLogin
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

   
postUserLoginR :: Handler Html
postUserLoginR = do
    ((result,_),_) <- runFormPost formUserLogin
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
                    redirect UserLoginR
                Just(Entity uid usr) -> do
                    if(userPassword usr == senha) then do
                        setSession "_NOME" (userUsername usr)
                        redirect HomeR
                    else do
                        setMessage[shamlet|
                            <div>
                                Senha invalida
                        |]
                        redirect UserLoginR
        _ -> redirect HomeR

postUserLogoutR :: Handler Html
postUserLogoutR = do
    deleteSession "_NOME"
    redirect HomeR