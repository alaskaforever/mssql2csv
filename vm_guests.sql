Select Distinct Top (1000000) tblAssets.AssetID,
  tblAssets.AssetName,
  tsysAssetTypes.AssetTypename,
  tblVmwareGuest.Ipv4Address,
  tblAssets1.AssetName As Host,
  tblVmwareGuest.CpuCount,
  tblVmwareGuest.EsxiKey,
  tblVmwareGuest.GuestFullName,
  tblVmwareGuest.GuestKey,
  tblVmwareGuest.InternalKey,
  tblVmwareGuest.IsRunning,
  tblVmwareGuest.lastchanged,
  tblVmwareGuest.Memory,
  tblVmwareGuest.NumEthernetCards,
  tblVmwareGuest.NumVirtualDisks,
  Case tblVmwareGuest.ToolsRunningStatus
    When 1 Then 'Executing scripts'
    When 2 Then 'Not running'
    When 3 Then 'Running'
  End As ToolsRunningStatus,
  tblVmwareGuest.ToolsVersion,
  Case tblVmwareGuest.ToolsVersionStatus
    When 1 Then 'Current'
    When 2 Then 'Out of date'
    When 3 Then 'Not installed'
    When 4 Then 'Unmanaged'
  End As ToolsVersionStatus,
  tblVmwareGuest.ToolsStatus,
  tblVmwareGuest.BootTime,
  tblVmwareGuest.UnsharedStorage,
  tblVmwareGuest.Version,
  tblAssets.Lastseen As [Last successful scan],
  tblAssets.Lasttried As [Last scan attempt]
From tblAssets
  Inner Join tblVmwareGuest On tblAssets.AssetID = tblVmwareGuest.AssetID
  Inner Join tsysAssetTypes On tsysAssetTypes.AssetType = tblAssets.Assettype
  Inner Join tblAssetCustom On tblAssets.AssetID = tblAssetCustom.AssetID
  Inner Join tblState On tblState.State = tblAssetCustom.State
  Left Outer Join tblVmwareInfo On tblVmwareGuest.HostID =
      tblVmwareInfo.VmwareID
  Left Outer Join tblAssets As tblAssets1 On tblAssets1.AssetID =
      tblVmwareInfo.AssetID
Where tblState.Statename = 'Active'
Order By tblVmwareGuest.Ipv4Address,
  tblAssets.AssetName

