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

{-
formThread :: Form Discussao
formThread = renderBootstrap $ Discussao
    <$> areq textField "Mensagem: " Nothing
    <*> aopt hiddenField "data" Nothing
    <*> aopt hiddenField "username" Nothing
-}

getThreadR :: Handler Html
getThreadR = do
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
        $(whamletFile "templates/thread.hamlet")
        $(whamletFile "templates/footer.hamlet")
        
{-
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

    -}

    


