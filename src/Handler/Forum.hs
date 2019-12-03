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

--formForum :: Form (Text,Text)
--formForum = renderBootstrap $ (,)
--    <$> areq textField "Titulo: " Nothing
--    <*> aopt hiddenField "username" Nothing

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
    ((result,_),_) <- runFormPost Form
    case result of
        FormSuccess (titulo) -> do
            hora <- currentTime
            runDB $ insert $ Forum titulo hora "teste"
            setMessage [shamlet|
                <h2>
                    Thread criada com sucesso!
            |]
            redirect ForumR
        _ -> redirect HomeR

    

    


