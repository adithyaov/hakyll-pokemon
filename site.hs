{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid ((<>))
import           Hakyll

main :: IO ()
main = hakyll $ do
    
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "assets/fonts/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "assets/css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "assets/js/*" $ do
        route idRoute
        compile copyFileCompiler

    match "templates/*" $ compile templateBodyCompiler

    create ["index.html"] $ do
      route idRoute
      compile $ do
        posts <- loadAll "posts/*"
        let indexContext = listField "posts" (constField "root" "." <> defaultContext) (return posts)
        let mainContext = constField "title" "Pokemon - Haykll" <>
                          field "body" (return . itemBody) <>
                          constField "root" "."
        makeItem ""
          >>= loadAndApplyTemplate "templates/index.html" indexContext
          >>= loadAndApplyTemplate "templates/default.html" mainContext

    match "posts/**" $ do
        route $ setExtension "html"
        compile $ do
            let mainContext = defaultContext
            pandocCompiler
              >>= loadAndApplyTemplate "templates/post.html" defaultContext
              >>= loadAndApplyTemplate "templates/default.html" mainContext 
              >>= relativizeUrls
    


