--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TupleSections #-}
import           Data.Monoid                 (mappend)
import           Data.Maybe                  (fromMaybe)
import           Data.List                   (sortBy)
import           Data.Ord                    (comparing)
import           Text.Read                   (readMaybe)
import           Control.Monad               (liftM, filterM)
import           Hakyll
import           Hakyll.Core.Metadata        (lookupString)

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "images/**" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    create ["robots.txt", "wayne@wycd.net.pub"] $ do
        route   idRoute
        compile copyFileCompiler

    match (fromList ["consulting.md", "now.md"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    tags <- buildTags "posts/*" (fromCapture "tags/*.html")
    tagsRules tags $ \tag pattern -> do
        let title = "Posts tagged \"" ++ tag ++ "\""
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll pattern
            let ctx = constField "title" title
                      `mappend` listField "posts" postCtx (return posts)
                      `mappend` defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/tag.html" ctx
                >>= loadAndApplyTemplate "templates/default.html" ctx
                >>= relativizeUrls

    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    (postCtxWithTags tags)
            >>= loadAndApplyTemplate "templates/default.html" (postCtxWithTags tags)
            >>= relativizeUrls

    create ["blog.html"] $ do
        route idRoute
        compile $ do
            posts <- regularPosts
            let blogCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Blog Posts"          `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/blog.html" blogCtx
                >>= loadAndApplyTemplate "templates/default.html" blogCtx
                >>= relativizeUrls

    match "projects/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/project.html" projectCtx
            >>= loadAndApplyTemplate "templates/default.html" projectCtx
            >>= relativizeUrls
                  
    create ["projects.html"] $ do
        route idRoute
        compile $ do
            projects <- byOrderMetadata =<< loadAll "projects/*"
            let projectsCtx =
                    listField "projects" projectCtx (return projects) `mappend`
                    constField "title" "Projects"                     `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/projects.html" projectsCtx
                >>= loadAndApplyTemplate "templates/default.html"  projectsCtx
                >>= relativizeUrls

    match "index.html" $ do
        route   idRoute
        compile $ do
            posts <- fmap (take 3) $ regularPosts
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Home"                `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler


--------------------------------------------------------------------------------
-- | Item Contexts
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

postCtxWithTags :: Tags -> Context String
postCtxWithTags tags = tagsField "tags" tags `mappend` postCtx

projectCtx :: Context String
projectCtx =
    defaultContext

--------------------------------------------------------------------------------
-- | Get regular posts
regularPosts = recentFirst =<< loadAll "posts/*"

--------------------------------------------------------------------------------
-- | Get posts by tag
postsByTag tag = recentFirst =<< keepTag tag =<< loadAll "posts/*"

--------------------------------------------------------------------------------
-- | Try to get a page's field as a Bool
getItemBool :: MonadMetadata m => String -> Identifier -> m Bool
getItemBool field id' = do
    metadata <- getMetadata id'
    return $ fromMaybe False $ readMaybe =<< lookupString field metadata
                                               

--------------------------------------------------------------------------------
-- | Try to get a page's field as an Integer
getItemInteger :: MonadMetadata m => String -> Identifier -> m Integer
getItemInteger field id' = do
    metadata <- getMetadata id'
    return $ fromMaybe 0 $ readMaybe =<< lookupString field metadata


--------------------------------------------------------------------------------
-- | Sort pages by their order metadata field, ascending
byOrderMetadata :: MonadMetadata m => [Item a] -> m [Item a]
byOrderMetadata =
    sortByM $ (getItemInteger "order") . itemIdentifier
  where
    sortByM :: (Monad m, Ord k) => (a -> m k) -> [a] -> m [a]
    sortByM f xs = liftM (map fst . sortBy (comparing snd)) $
                   mapM (\x -> liftM (x,) (f x)) xs

--------------------------------------------------------------------------------
-- | Generic function to filter items by their tags
filterTag :: MonadMetadata m => Bool -> String -> [Item a] -> m [Item a]
filterTag keep tagName =
    filterM filterFn
  where
    sign = if keep then id else not
    filterFn :: MonadMetadata m => Item a -> m Bool
    filterFn item = fmap (sign . elem tagName) $ getTags . itemIdentifier $ item

--------------------------------------------------------------------------------
-- | Keep items if they have a certain tag
keepTag :: MonadMetadata m => String -> [Item a] -> m [Item a]
keepTag = filterTag True

--------------------------------------------------------------------------------
-- | Exclude items if they have a certain tag
excludeTag :: MonadMetadata m => String -> [Item a] -> m [Item a]
excludeTag = filterTag False
