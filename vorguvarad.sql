Select Top 1000000 a.AssetID,
  a.AssetName,
  t.AssetTypename,
  t.AssetTypeIcon10 As icon,
  a.IPAddress,
  tsysIPLocations.IPLocation,
  a.Lastseen,
  a.Lasttried,
  ac.Location,
  ac.Building,
  ac.Department,
  ac.Manufacturer,
  ac.Contact,
  ac.Model
From tblAssets a
  Inner Join tblAssetCustom ac On a.AssetID = ac.AssetID
  Inner Join tsysAssetTypes t On t.AssetType = a.AssetType
  Inner Join tsysIPLocations On a.LocationID = tsysIPLocations.LocationID
Where t.AssetTypename Not In ('ESXi server', 'Windows', 'Linux', 'Location',
  'VMware Guest', 'Mail Server') And ac.State = 1 And Not Exists(Select 1
    From tblComputerSystem cs Inner Join tblAssets a2 On cs.AssetID = a2.AssetID
      Inner Join tblAssetCustom ac2 On a2.AssetID = ac2.AssetID
    Where cs.DomainRole < 2 And ac2.State = 1 And a2.AssetID = a.AssetID)
