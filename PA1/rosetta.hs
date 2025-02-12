import System.IO
import Data.Graph
import Data.List
import Distribution.Utils.Generic (fstOf3)

toPairs :: [a] -> [(a, a)]
toPairs []       = []
toPairs [_]      = []
toPairs (x:y:xs) = (x, y) : toPairs xs

postorder :: Ord a => Tree a -> [a]
postorder (Node a ts) = postorderF (sort ts) ++ [a]

postorderF   :: Ord a => Forest a -> [a]
postorderF = concatMap postorder

sortPairs :: Ord a => [(a, a)] -> Maybe [a]
sortPairs pairs = if cyclePresent then Nothing else Just sortedNodes
    where
        nodes = sort $ nub $ concat [[x, y] | (x, y) <- pairs]
        edges = [(v, v, [d | (x, d) <- pairs, x == v]) | v <- nodes]
        (graph, nodeFromVertex, vertexFromKey) = graphFromEdges edges
        cyclePresent = any isCyclic $ stronglyConnComp edges
        forest = dff graph
        sorted = postorderF forest
        sortedNodes = fstOf3 . nodeFromVertex <$> sorted

        isCyclic (AcyclicSCC _) = False
        isCyclic (CyclicSCC _) = True

main :: IO ()
main = do
    inp <- getContents
    let ls = lines inp
    case sortPairs $ toPairs ls of
        Just strings -> mapM_ putStrLn strings
        Nothing -> putStrLn "cycle"