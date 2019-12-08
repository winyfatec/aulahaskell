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

-- Formata a data e a hora
dateFormat :: UTCTime -> String
dateFormat = formatTime defaultTimeLocale "%d/%m/%Y %H:%M:%S"

getForumR :: Handler Html
getForumR = do
    threads <- runDB $ selectList [] [Asc ForumTitulo]
    sess <- lookupSession "_NOME"
--    (widget,enctype) <- generateFormPost formForum
    defaultLayout $ do
        setTitle "Aula Haskell Fatec :: Forum"
        addStylesheet $ StaticR css_main_css
        addScript $ StaticR js_main_js
        toWidgetHead [hamlet|
            <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
            <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
            <script>
                (adsbygoogle = window.adsbygoogle || []).push({ google_ad_client: "ca-pub-3156965201812393",enable_page_level_ads: true});
            <script src="https://code.jquery.com/jquery-3.4.1.min.js" integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo=" crossorigin="anonymous">
            <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous">
            <script src="https://cdnjs.cloudflare.com/ajax/libs/modernizr/2.8.3/modernizr.min.js" integrity="sha256-0rguYS0qgS6L4qVzANq4kjxPLtvnp5nn2nB5G1lWRv4=" crossorigin="anonymous">
        |]
        msg <- getMessage
        $(whamletFile "templates/header.hamlet")
        $(whamletFile "templates/menu.hamlet")
        $(whamletFile "templates/forum.hamlet")
        $(whamletFile "templates/footer.hamlet")
        
        
        
        
   
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



