Select Top 1000000 u.Username,
  u.Userdomain,
  u.Firstname,
  u.Lastname,
  u.Name,
  u.Displayname,
  u.email As Email,
  o.sAMAccountName As ManagerUsername,
  o.domain As ManagerDomain,
  m.Displayname As ManagerDisplayname,
  u.Telephone,
  u.Mobile,
  u.Street,
  u.City,
  u.Country,
  u.Title,
  u.Department,
  u.Company,
  u.EmployeeNumber,
  u.EmployeeID,
  u.Info
From tblADusers u
  Left Join tblADObjects o On o.ADObjectID = u.ManagerADObjectId
  Left Join tblADusers m On m.ADObjectID = u.ManagerADObjectId
Order By u.Userdomain,
  u.Username
