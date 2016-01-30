-- User settings

spinnerIndex = 0;
spinnerTurretIndex = 3; --WeaponsOnSpinnerTurret index
weaponSlot = 5;


-- Script variables

initialized = false;

count = 0;
rotationIndex = 3;
rotationAngle = {0, 90, 180, -90};
rotationMaxIndex = 4;
rotationSeconds = 10;
fireSeconds = 5;
tickRate = 40;
didFire = false;

weaponList = {}
maxWeapons = 1;
weaponShootOrder = {2,3,0,1};
weaponIndex = 1;

function Update(I)

    if not initialized then
        init(I);
        initialized = true;
    end

    count = count + 1;
    
    -- Check if we need to fire
    
    if count > tickRate * fireSeconds and not didFire then
        doFire(I)
        didFire = true;
    end
    
    -- Rotate
    if count > tickRate * rotationSeconds then

        plusRotate(I)

        
        
        didFire = false;
        count = 0;
    
    end
end

function plusRotate(I)

    rotationIndex = rotationIndex + 1;
    if rotationIndex > rotationMaxIndex then
        rotationIndex = 1;
    end
    
    I:Log('rolling'..rotationAngle[rotationIndex])
    I:SetSpinnerRotationAngle(spinnerIndex,rotationAngle[rotationIndex]);

end

function doFire(I)
    I:Log('fire'..weaponShootOrder[weaponIndex]);
    --local weaponSlot = weaponList[weaponShootOrder[weaponIndex + 1]].WeaponSlot;
    I:FireWeaponOnTurretOrSpinner(spinnerTurretIndex,weaponShootOrder[weaponIndex], weaponSlot);
    weaponIndex = weaponIndex + 1;
    if weaponIndex >= maxWeapons then
        weaponIndex = 1;
    end
end

function init(I)

    -- find and save weapons on a spinner

    I:Log('init')
    local weaponID = 0;
    local numWeapons = I:GetWeaponCountOnTurretOrSpinner(spinnerTurretIndex);
    
    for weaponID=0,numWeapons,1 do
    
        local v = I:GetWeaponInfoOnTurretOrSpinner(spinnerTurretIndex, weaponID);
    
        -- I:Log('found a weapon'..v.WeaponType)
    
        if v.Valid and v.WeaponType == 5 then
            I:Log('found a missile launcher ID:'..weaponID)
            weaponList[maxWeapons] = v;
            maxWeapons = maxWeapons + 1;
        end
    end

end
