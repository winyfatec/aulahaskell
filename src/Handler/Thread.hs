{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Thread where

import Import
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius

formThread :: Form Thread
formThread = renderBootstrap $ Thread
    <$> areq textField "Mensagem: " Nothing
    <*> aopt hiddenField "data" Nothing
    <*> aopt hiddenField "username" Nothing

getThreadR :: Handler Html
getThreadR = do
    defaultLayout $ do
        msg <- getMessage
        [whamlet|
            $maybe mensa <- msg
                <div>
                    ^{mensa}
            $nothing
                
        |]

postThreadR :: Handler Html
postThreadR = do
    ((result,_),_) <- runFormPost formThread
    case result of
        FormSuccess Thread -> do
            runDB $ insert Thread
            setMessage [shamlet|
                <h2>
                    Thread criada com sucesso!
            |]
            redirect ThreadR
        _ -> redirect HomeR

    

    


