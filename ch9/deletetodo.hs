import System.IO
import System.Directory
import Data.List
import Control.Exception

main = do 
	contents <- readFile "todo.txt"
	let todoTasks = lines contents
	let numberedTasks = zipWith (\n line -> show n ++ " - " ++ line) [0..] todoTasks
		
	putStrLn "These are your TO-DO items:"
	mapM_ putStrLn numberedTasks
	putStrLn "Which one do you want me to delete?"
	numberString <- getLine
	
	let number = read numberString
	let newTodoItems = unlines $ delete (todoTasks !! number) todoTasks
	
	bracketOnError (openTempFile "." "temp")
		(\(tempName, tempHandle) -> do 
  			hClose tempHandle
			removeFile tempName)
		(\(tempName, tempHandle) -> do
			hPutStr tempHandle newTodoItems
			hClose tempHandle
			removeFile "todo.txt"
			renameFile tempName "todo.txt")	
	