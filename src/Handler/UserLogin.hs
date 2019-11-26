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


formUserLogin :: Form (Text,Text)
formUserLogin  = renderBootstrap $ (,)
    <$> areq emailField "Email" Nothing
    <*> areq passwordField "Senha" Nothing



getUserLoginR :: Handler Html
getUserLoginR = do
    (widget,enctype) <- generateFormPost formUserLogin
    defaultLayout $ do
        msg <- getMessage
        [whamlet|
            $maybe mensa <- msg
                <div>
                    ^{mensa}
            $nothing
            
            <h1>
                Login
            <form method=post action=@{UserLoginR}>
                ^{widget}
                <input type="submit" value="Entrar">
        |]

   
postUserLoginR :: Handler Html
postUserLoginR = do
    ((result,_),_) <- runFormPost formUserLogin
    case result of
        FormSuccess ("root@root.com","root") -> do
            setSession "_NOME" "root"
            redirect HomeR
        FormSuccess (username,senha) -> do
            usuario <- runDB $ getBy (Username username)
            case usuario of
                Nothing -> do
                    setMessage[shamlet|
                        <div>
                            Usuario nao encntrado
                    |]
                    redirect UserLoginR
                Just(Entity _ usr) -> do
                    if(userPassword usr == senha) then do
                        setSession "_NOME" (userUserame usr)
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
    
    
getAdminR :: Handler Html
getAdminR = do
    defaultLayout[whamlet|
        <h1>
            Bem vindo
    |]