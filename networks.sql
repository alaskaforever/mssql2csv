Select Top (1000000) tblAssets.AssetID,
  tblAssets.AssetName,
  tsysAssetTypes.AssetTypename,
  tsysAssetTypes.AssetTypeIcon10 As icon,
  tblAssets.IPAddress,
  tblAssets.Lastseen As [Last successful scan],
  tblAssets.Lasttried As [Last scan attempt],
  tblVmwareNetwork.Name,
  tblVmwareNetwork.IPAddress As IPAddress1,
  tblVmwareNetwork.Subnet,
  tblVmwareNetwork.MAC,
  tblVmwareNetworkTypes.Name As NetworkType,
  tblVmwareNetwork.IPv6Addresses,
  tblVmwareNetwork.Speed,
  tblVmwareNetwork.Mtu,
  tblVmwareNetwork.lastchanged
From tblAssets
  Inner Join tblAssetCustom On tblAssets.AssetID = tblAssetCustom.AssetID
  Inner Join tblState On tblState.State = tblAssetCustom.State
  Inner Join tsysAssetTypes On tsysAssetTypes.AssetType = tblAssets.Assettype
  Inner Join tblVmwareInfo On tblAssets.AssetID = tblVmwareInfo.AssetID
  Inner Join tblVmwareNetwork On tblVmwareInfo.VmwareID =
      tblVmwareNetwork.HostID
  Inner Join tblVmwareNetworkTypes On tblVmwareNetwork.NetworkType =
      tblVmwareNetworkTypes.NetworkTypeID
Where tblState.Statename = 'Active'
Order By tblAssets.IPAddress,
  tblAssets.AssetName

