{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE ViewPatterns #-}

module Foundation where

import Import.NoFoundation
import Database.Persist.Sql (ConnectionPool, runSqlPool)
import Yesod.Core.Types     (Logger)

data App = App
    { appSettings    :: AppSettings
    , appStatic      :: Static 
    , appConnPool    :: ConnectionPool 
    , appHttpManager :: Manager
    , appLogger      :: Logger
    }

mkYesodData "App" $(parseRoutesFile "config/routes")

instance Yesod App where
    makeLogger = return . appLogger
    --authRoute _ = return (Just LoginR)
    authRoute _ = Just $ LoginR
    isAuthorized HomeR _ = return Authorized
    isAuthorized AulaR _ = return Authorized
    isAuthorized UsuarioR _ = return Authorized
    isAuthorized LoginR _ = return Authorized
    isAuthorized (StaticR _) _ = return Authorized
    isAuthorized AdminR _ = isRoot
    isAuthorized _ _ = isUsuario
    isAuthorized AtorR _ = return Authorized
    isAuthorized SerieR _ = return Authorized
    isAuthorized AtuaR _ = return Authorized
    isAuthorized (ElencoR _) _ = return Authorized
       
isUsuario :: Handler AuthResult
isUsuario = do
    sess <- lookupSession "_NOME"
    case sess of
        Nothing -> return AuthenticationRequired
        (Just _) -> return Authorized 
isRoot :: Handler AuthResult
isRoot = do
    sess <- lookupSession "_NOME"
    case sess of
        Nothing -> return AuthenticationRequired
        (Just "Root") -> return Authorized
        (Just _) -> return (Unauthorized "Voce nao e admin") 
        

 

type Form a = Html -> MForm Handler (FormResult a, Widget)

instance YesodPersist App where
    type YesodPersistBackend App = SqlBackend
    runDB action = do
        master <- getYesod
        runSqlPool action $ appConnPool master

instance RenderMessage App FormMessage where
    renderMessage _ _ = defaultFormMessage

instance HasHttpManager App where
    getHttpManager = appHttpManager
