{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.UserConfig where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius
import Yesod
import Yesod.Form.Bootstrap3


formUserConfig :: Form Usuario
formUserConfig  = renderBootstrap $ Usuario
    <$> areq textField nomeUsuario (Just (lookupSession "_NOME"))
    <*> areq passwordField (bfs ("Senha" :: Text)) Nothing
    where nomeUsuario = withAutofocus $ withPlaceholder "Nome de usuário..." $ (bfs ("Nome de Usuário" :: Text))

getUserConfigR :: Handler Html
getUserConfigR = do
    sess <- lookupSession "_NOME"
    (widget,enctype) <- generateFormPost formUserConfig
    defaultLayout $ do
        msg <- getMessage
        setTitle "Aula Haskell Fatec :: Configuração da conta"
        addStylesheet $ StaticR css_main_css
        addScript $ StaticR js_main_js
        toWidgetHead [hamlet|
            <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
        |]
        $(whamletFile "templates/userconfig.hamlet")
        $(whamletFile "templates/footer.hamlet")

   
postUserConfigR :: Handler Html
postUserConfigR = do
    ((result,_),_) <- runFormPost formUserConfig
    case result of
        FormSuccess user -> do
            --sess <- lookupSession "_ID"
            --runDB $ updateWhere [uid ==. sess] [username *=. (userUsername user)]
            setMessage [shamlet|
                <h2>
                    Dados atualizados com sucesso!
            |]
            redirect UserConfigR
        _ -> redirect HomeR