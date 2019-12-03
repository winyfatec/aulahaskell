{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Forum where

import Import
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius
{-
formForum :: Form Forum
formForum = renderBootstrap $ Forum
    <$> areq textField "Titulo" Nothing
    <*> aopt dayField "Data" Nothing
    <*> aopt textField "username" Nothing
-}
getForumR :: Handler Html
getForumR = do
    threads <- runDB $ selectList [] [Asc ForumFkUsername]
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
    newsUrl <- lookupPostParam "criarnovo"
    case newsUrl of
        Just forum -> do
            runDB $ insert $ forum 
            setMessage [shamlet|
                <h2>
                    Thread criada com sucesso!
            |]
            redirect ForumR
        _ -> redirect HomeR

    

    


