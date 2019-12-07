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

formRegister :: Form User
formRegister  = renderBootstrap $ User
    <$> areq textField "Nome de usuário: " Nothing
    <*> areq passwordField "Senha: " Nothing

getRegisterR :: Handler Html
getRegisterR = do
    (widget,enctype) <- generateFormPost formRegister
    defaultLayout $ do
        msg <- getMessage
        [whamlet|
            $maybe mensa <- msg
                <div>
                    ^{mensa}
            $nothing
            
            <h1>
                Cadastro de Usuario
            <form method=post action=@{RegisterR}>
                ^{widget}
                <input .btn.btn-primary type="submit" value="Registrar">
        |]


postRegisterR :: Handler Html
postRegisterR = do
    ((result,_),_) <- runFormPost formRegister
    case result of
        FormSuccess user -> do
            runDB $ insert user
            setMessage [shamlet|
                <h2>
                    Usuário inserido com sucesso
            |]
            redirect RegisterR
        _ -> redirect HomeR

