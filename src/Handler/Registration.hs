{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Registration where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius
import Yesod
import Yesod.Form.Bootstrap3

formRegister :: Form Usuario
formRegister  = renderBootstrap $ Usuario
    <$> areq textField nomeUsuario Nothing
    <*> areq passwordField (bfs ("Senha" :: Text)) Nothing
    where nomeUsuario = withAutofocus $ withPlaceholder "Nome de usuário..." $ (bfs ("Nome de Usuário" :: Text))

getRegisterR :: Handler Html
getRegisterR = do
    (widget,enctype) <- generateFormPost formRegister
    defaultLayout $ do
        msg <- getMessage
        setTitle "Aula Haskell Fatec :: Registrar usuário"
        sess <- lookupSession "_NOME"
        addStylesheet $ StaticR css_main_css
        addScript $ StaticR js_main_js
        toWidgetHead [hamlet|
            <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
            <script src="https://code.jquery.com/jquery-3.4.1.min.js" integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo=" crossorigin="anonymous">
            <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous">
            <link rel="shortcut icon" href="@{StaticR icons_fontawesome_solid_crosshairs_svg}" type="image/x-icon" />
        |]

        $(whamletFile "templates/register.hamlet")
        $(whamletFile "templates/footer.hamlet")


postRegisterR :: Handler Html
postRegisterR = do
    ((result,_),_) <- runFormPost formRegister
    case result of
        FormSuccess user -> do
            runDB $ insert user
            setMessage [shamlet|
                Cadastro efetuado com sucesso
                <br>
                <a href="@{LoginR}" .btn.btn-primary>
                    Logar
            |]
            redirect RegisterR
        _ -> redirect HomeR

