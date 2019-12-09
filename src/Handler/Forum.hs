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
import Data.Text

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
    sess <- lookupSession "_NOME"
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
    Just username <- lookupSession "_NOME"
    --Just usuario <- runDB $ getBy (UniqueUsername username)
    Just (Entity pid _) <- runDB $ getBy (UniqueUsername username)
    -- Just uid <- runDB $ get (UserId usuario)
    criado <- (liftIO getCurrentTime)
    case cria of
        Just titulo -> do
            runDB $ insert $ Forum titulo pid criado
            setMessage [shamlet|
                Thread criada com sucesso!
            |]
            redirect ForumR
        _ -> redirect HomeR


getThreadR :: ForumId -> Handler Html
getThreadR tid = do
    sess <- lookupSession "_NOME"
    let sql = "SELECT ??,??,?? FROM mensagem INNER JOIN forum ON mensagem.fk_Forum_Id = forum.id INNER JOIN usuario ON mensagem.fk_User_Id = usuario.id WHERE forum.id = ?"
    thread <- runDB $ get404 tid
    mensagens <- runDB $ rawSql sql [toPersistValue tid] :: Handler [(Entity Forum,Entity Mensagem,Entity Usuario)]
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
        
        

        
   
postMensagemR :: ForumId -> Handler Html
postMensagemR fid = do
    texto <- lookupPostParam "mensagem"
    Just username <- lookupSession "_NOME"
    Just (Entity pid _) <- runDB $ getBy (UniqueUsername username)
    postada <- (liftIO getCurrentTime)
    case texto of
        Just txt -> do
            runDB $ insert $ Mensagem fid pid txt postada
            setMessage [shamlet|
                Mensagem postada com sucesso!
            |]
            redirect ThreadR fid
        _ -> redirect HomeR


-- postMensagemR :: Handler Html
-- postMensagemR = do
--     mensagem <- lookupPostParam "mensagem"
--     forumId <- lookupPostParam "forumId"
--     Just username <- lookupSession "_NOME"
--     Just (Entity uid _) <- runDB $ getBy (UniqueUsername username)
--     Just (Entity fid _) <- runDB $ selectList [ForumId ==. forumId] []
--     -- Just uid <- runDB $ get (UserId usuario)
--     criado <- (liftIO getCurrentTime)
--     case mensagem of
--         Just titulo -> do
--             runDB $ insert $ Mensagem fid uid mensagem criado
--             setMessage [shamlet|
--                 Thread criada com sucesso!
--             |]
--             redirect ForumR
--         _ -> redirect HomeR