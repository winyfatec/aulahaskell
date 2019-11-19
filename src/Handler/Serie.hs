{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Serie where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius


formSerie :: Form Serie
formSerie  = renderBootstrap $ Serie
    <$> areq textField "Nome" Nothing
    <*> areq dayField "Nascimento" Nothing



getSerieR :: Handler Html
getSerieR = do
    (widget,enctype) <- generateFormPost formSerie
    defaultLayout $ do
        msg <- getMessage
        [whamlet|
            $maybe mensa <- msg
                <div>
                    ^{mensa}
            $nothing
            
            <h1>
                Cadastro de Serie
            <form method=post action=@{SerieR}>
                ^{widget}
                <input type="submit" value="Cadastrar">
        |]


postSerieR :: Handler Html
postSerieR = do
    ((result,_),_) <- runFormPost formSerie
    case result of
        FormSuccess serie -> do
            runDB $ insert serie
            setMessage [shamlet|
                <h2>
                    Serie inserido com sucesso
            |]
            redirect SerieR
        _ -> redirect HomeR

