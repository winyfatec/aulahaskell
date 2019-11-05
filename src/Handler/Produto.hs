{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Produto where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius

formProduto :: Form Produto
formProduto = renderBootstrap $ Produto
    --require
    <$> areq textField "Nome: " Nothing
    <*> areq doubleField "Preco: " Nothing

getProdutoR :: Handler Html
getProdutoR = do
    defaultLayout $ do
        (widget,enctype) <- generateFormPost formProduto
        msg <- getMessage
        [whamlet|
            <div>
                ^{msg}
            <h1>
                Cadastro de Produtos
            <form method=post action=@{ProdutoR}>
                ^{widget}
        |]

postProdutoR :: Handler Html
postProdutoR = do
    ((result,_),_) <- runFormPost formProduto
    case result of
        FormSuccess produto -> do
            runDB $ insert produto
            setMessage [shamlet|
                <h2>
                    Produto inserido com sucesso
            |]
            redirect ProdutoR
        _ -> redirect HomeR
        


