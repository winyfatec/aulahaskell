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


formLogin :: Form (Text,Text)
formLogin  = renderBootstrap $ (,)
    <$> areq emailField "Email" Nothing
    <*> areq passwordField "Senha" Nothing



getLoginR :: Handler Html
getLoginR = do
    (widget,enctype) <- generateFormPost formLogin
    defaultLayout $ do
        msg <- getMessage
        [whamlet|
            $maybe mensa <- msg
                <div>
                    ^{mensa}
            $nothing
            
            <h1>
                Login
            <form method=post action=@{LoginR}>
                ^{widget}
                <input type="submit" value="Entrar">
        |]


postLoginR :: Handler Html
postLoginR = do
    ((result,_),_) <- runFormPost formLogin
    case result of
        FormSuccess ("root@root.com","root") -> do
            setSession "_NOME" "root"
            redirect HomeR
        FormSuccess (usuario,senha) -> do
            usuario <- runDB $ getBy (UniqueEmailAdm email)
            case usuario of
                Nothing -> do
                    setMessage[shamlet|
                        <div>
                            Email nao encntrado
                    |]
                    redirect LoginR
                Just(Entity _ usr) -> do
                    if(usuarioSenha usr == senha) then do
                        setSession "_NOME" (usuarioNome usr)
                        redirect HomeR
                    else do
                        setMessage[shamlet|
                            <div>
                                Senha invalida
                        |]
                        redirect LoginR
        _ -> redirect HomeR

postLogoutR :: Handler Html
postLogoutR = do
    deleteSession "_NOME"
    redirect HomeR
    
    
getAdminR :: Handler Html
getAdminR = do
    defaultLayout[whamlet|
        <h1>
            Bem vindo
    |]