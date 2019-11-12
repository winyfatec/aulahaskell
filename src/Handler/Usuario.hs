{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Usuario where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius


formUsuario :: Form Usuario
formUsuario  = renderBootstrap $ Usuario
    <$> areq textField "Nome" Nothing
    <*> areq emailField "Email" Nothing
    <*> areq passwordField "Senha" Nothing



getUsuarioR :: Handler Html
getUsuarioR = do
    (widget,enctype) <- generateFormPost formUsuario
    defaultLayout $ do
        msg <- getMessage
        [whamlet|
            $maybe mensa <- msg
                <div>
                    ^{mensa}
            $nothing
            
            <h1>
                Cadastro de Usuario
            <form method=post action=@{UsuarioR}>
                ^{widget}
                <input type="submit" value="Cadastrar">
        |]


postUsuarioR :: Handler Html
postUsuarioR = do
    ((result,_),_) <- runFormPost formUsuario
    case result of
        FormSuccess usuario -> do
            runDB $ insert usuario
            setMessage [shamlet|
                <h2>
                    Usuario inserido com sucesso
            |]
            redirect UsuarioR
        _ -> redirect HomeR

