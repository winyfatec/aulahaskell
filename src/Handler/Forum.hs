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
-}
{-
formForum :: Form Text 
formForum = renderDivs $ (
    <$> areq textField "Titulo" Nothing
-}  

formForum = do
    (titulo, tituloField) <- textField "Titulo" Nothing
    (dt, dateField) <- textField "Data" Nothing
    (username, usernameField) <- textField "Username" Nothing
    return (Forum <$> titulo <*> dt <*> username, [$hamlet|
    Teste ^fiInput.tituoField^ teste dois ^fiInput.dateField^  teste tres ^fiInput.usernameField^
    |])



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
{-
postForumR :: Handler Html
postForumR = do
    cria <- lookupPostParam "criarnovo"
    case cria of
        Just forum -> do
            runDB $ insert forum
            setMessage [shamlet|
                <h2>
                    Thread criada com sucesso!
            |]
            redirect ForumR
        _ -> redirect HomeR
-}
    


