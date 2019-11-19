{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Atua where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius

seriesCB = do
    rows <- runDB $ selectList [] [Asc SerieNome]
    optionsPairs $ 
        map (\r -> (serieNome $ entityVal r, entityKey r)) row
        

atorCB = do
    rows <- runDB $ selectList [] [Asc AtorNome]
    optionsPairs $ 
        map (\r -> (atorNome $ entityVal r, entityKey r)) row
        
formAtua :: Form Atua
formAtua  = renderBootstrap $ Atua
    <$> areq (selectField serieCB) "Serie" Nothing
    <*> areq (selectField atorCB) "Ator" Nothing
    <*> areq intField "Ano" Nothing


getAtuaR :: Handler Html
getAtuaR = do
    (widget,enctype) <- generateFormPost formAtua
    defaultLayout $ do
        msg <- getMessage
        [whamlet|
            $maybe mensa <- msg
                <div>
                    ^{mensa}
            $nothing
            
            <h1>
                Cadastro de Atuacao
            <form method=post action=@{AtuaR}>
                ^{widget}
                <input type="submit" value="Cadastrar">
        |]


postAtuaR :: Handler Html
postAtuaR = do
    ((result,_),_) <- runFormPost formAtua
    case result of
        FormSuccess atua -> do
            runDB $ insert atua
            setMessage [shamlet|
                <h2>
                    Atuacao inserido com sucesso
            |]
            redirect AtuaR
        _ -> redirect HomeR

