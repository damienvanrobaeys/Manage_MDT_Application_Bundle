
Function Add-Dependency
	{
		Param
		(
			[string]$DeploymentShare,				
			[string]$App_Name,		
			[string]$Bundle_Name			
		)	
		
		$Apps_XML = "$DeploymentShare\Control\Applications.xml"
		$Get_Apps_Content = [xml](get-Content $Apps_XML)
		
		$Get_App_to_manage = $Get_Apps_Content.Applications.application | Where{(($_.Source -ne $null) -and ($_.Name -like "*$App_Name*"))}
		$Get_App_GUID = $Get_App_to_manage.guid
		$Get_App_Name = $Get_App_to_manage.name
		
		$Get_App_Bundle = $Get_Apps_Content.Applications.application | Where{(($_.Source -eq $null) -and ($_.Name -like "*$Bundle_Name*"))}		
		$Get_Bundle_Name = $Get_App_Bundle.name		

		$New_Appli_Dependency = $Get_App_Bundle.AppendChild($Get_Apps_Content.CreateElement("Dependency"));

		$Dependency_Value = $New_Appli_Dependency.AppendChild($Get_Apps_Content.CreateTextNode($Get_App_GUID));
		$Get_Apps_Content.Save($Apps_XML);	
		write-host "Application $Get_App_Name has been added in $Get_Bundle_Name "
	}
	
Add-Dependency -DeploymentShare	"D:\backup\DeploymentShare2" -App_Name "app2" -Bundle_Name "bundle"
	

	
Function Remove-Dependency
	{
		Param
		(
			[string]$DeploymentShare,				
			[string]$App_Name,		
			[string]$Bundle_Name			
		)	
		
		$Apps_XML = "$DeploymentShare\Control\Applications.xml"
		$Get_Apps_Content = [xml](get-Content $Apps_XML)
		
		$Get_App_to_manage = $Get_Apps_Content.Applications.application | Where{(($_.Source -ne $null) -and ($_.Name -like "*$App_Name*"))}
		$Get_App_GUID = $Get_App_to_manage.guid

		$Get_App_Bundle = $Get_Apps_Content.Applications.application | Where{(($_.Source -eq $null) -and ($_.Name -like "*$Bundle_Name*"))}
		$GetApp_Dependency = $Get_App_Bundle.SelectNodes("Dependency") | Where {$_."#text" -eq $Get_App_GUID}
		$GetApp_Dependency.ParentNode.RemoveChild($GetApp_Dependency) | out-null
		$Get_Apps_Content.Save($Apps_XML);	
		write-host "Application $Get_App_Name has been removed from $Get_Bundle_Name "		
	}	
	
Remove-Dependency -DeploymentShare "D:\backup\DeploymentShare2" -App_Name "app2" -Bundle_Name "bundle"
	
	
	
	
	
	 

	


