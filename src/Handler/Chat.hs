{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Chat where

import Import
import Text.Lucius
import Text.Julius
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Data.Time
import Control.Monad.IO.Class

-- renderDivs
formChat :: Form (_,_,Text)
formChat = renderBootstrap $ Chat
    <$> areq textField "Mensagem: " Nothing

getChatR :: Handler Html
getChatR = do 
    (widget,_) <- generateFormPost formChat
    msg <- getMessage
    defaultLayout $ 
        [whamlet|
            $maybe mensa <- msg 
                <div>
                    ^{mensa}
            
            <h1>
                Chat
            
            <form method=post action=@{ChatR}>
                ^{widget}
                <input type="submit" value="Enviar">
        |]

postChatR :: Handler Html
postChatR = do 
    ((result,_),_) <- runFormPost formChat
    case result of 
        FormSuccess (mensagem) -> do 
            username <- lookupSession "_NOME"
            now <- liftIO getCurrentTime
            runDB $ insert $ username now mensagem 
            setMessage [shamlet|
                <div>
                    MENSAGEM POSTADA
            |]
            redirect ChatR
        _ -> redirect HomeR


