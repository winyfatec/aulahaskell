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

-- $F =  %Y-%m-%d
dateFormat :: UTCTime -> String
dateFormat = formatTime defaultTimeLocale "%d/$m/$Y"

getForumR :: Handler Html
getForumR = do
    threads <- runDB $ selectList [] [Asc ForumTitulo]
--    (widget,enctype) <- generateFormPost formForum
    defaultLayout $ do
        msg <- getMessage
        [whamlet|
            $maybe mensa <- msg
                <div>
                    ^{mensa}
            $nothing
                
        |]
        $(whamletFile "templates/forum.hamlet")
        
        
        
        
   
postForumR :: Handler Html
postForumR = do
    cria <- lookupPostParam "titulo"
    Just username <- lookupSession "_NOME"
    criado <- (liftIO getCurrentTime)
    case cria of
        Just titulo -> do
            runDB $ insert $ Forum titulo username criado
            setMessage [shamlet|
                <h2>
                    Thread criada com sucesso!
            |]
            redirect ForumR
        _ -> redirect HomeR



