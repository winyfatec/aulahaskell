{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Forum where

import Import
import Database.Persist
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius
import Data.Time
import Control.Monad.IO.Class
import Data.Time.Format
import Data.Int
import Data.Text.Read

{-
formForum :: Form Forum 
formForum = renderBootstrap $ Forum
    <$> areq textField "Titulo" Nothing
-}
{-
formForum :: Form Text 
formForum = renderDivs $ (
    <$> areq textField "Titulo" Nothing
-}  

-- Formata a data e a hora
dateFormat :: UTCTime -> String
dateFormat = formatTime defaultTimeLocale "%d/%m/%Y %H:%M:%S"

getForumR :: Handler Html
getForumR = do
    threads <- runDB $ selectList [] [Desc ForumCriado]
    sess <- lookupSession "_USUARIO"
--    (widget,enctype) <- generateFormPost formForum
    defaultLayout $ do
        setTitle "Aula Haskell Fatec :: Forum"
        addStylesheet $ StaticR css_main_css
        addScript $ StaticR js_main_js
        toWidgetHead [hamlet|
            <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
            <script src="https://code.jquery.com/jquery-3.4.1.min.js" integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo=" crossorigin="anonymous">
            <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous">
       |]
        msg <- getMessage
        $(whamletFile "templates/menu.hamlet")
        $(whamletFile "templates/forum.hamlet")
        $(whamletFile "templates/footer.hamlet")
        
        
        
        
   
postForumR :: Handler Html
postForumR = do
    cria <- lookupPostParam "titulo"
    Just userId <- lookupSession "_USUARIO"
    Just usuario <- runDB $ get404 (toSqlKey (read (userId :: Int64)))
    -- Just uid <- runDB $ get (UserId usuario)
    t <- read userId :: Int64
    criado <- (liftIO getCurrentTime)
    case cria of
        Just titulo -> do
            --runDB $ insert $ Forum titulo (UserId usuario) criado
            setMessage [shamlet|
                Thread criada com sucesso!
            |]
            redirect ForumR
        _ -> redirect HomeR


getThreadR :: ForumId -> Handler Html
getThreadR tid = do
    sess <- lookupSession "_USUARIO"
    let sql = "SELECT ??,??,?? FROM forum INNER JOIN mensagem ON mensagem.fkForumId = forum.id INNER JOIN user ON mensagem.fkUserId = user.id WHERE forum.id = ?"
    thread <- runDB $ get404 tid
    mensagens <- runDB $ rawSql sql [toPersistValue tid] :: Handler [(Entity Forum,Entity Mensagem,Entity User)]
    -- (widget,enctype) <- generateFormPost formForum
    defaultLayout $ do
        setTitle "Aula Haskell Fatec :: Forum"
        addStylesheet $ StaticR css_main_css
        addScript $ StaticR js_main_js
        toWidgetHead [hamlet|
            <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
            <script src="https://code.jquery.com/jquery-3.4.1.min.js" integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo=" crossorigin="anonymous">
            <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous">
        |]
        msg <- getMessage
        $(whamletFile "templates/menu.hamlet")
        $(whamletFile "templates/thread.hamlet")
        $(whamletFile "templates/footer.hamlet")
        
  
        
        