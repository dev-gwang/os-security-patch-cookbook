## 부모경로를 가져옴

currentPath	= File.dirname(__FILE__) ## 현재 파일의 경로를 가지고 옴
currentPathTemp	= currentPath.split('/')
currentPath.gsub!(currentPathTemp[currentPathTemp.size - 1], "")

file_cache_path	"/tmp/chef-solo"
cookbook_path	["#{currentPath}"]	## 위치를 변경 후에 사용할 것
