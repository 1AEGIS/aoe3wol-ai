const int numCivilizations = 40;
int currentEnemy = -1;


int select( int unit = -1, int owner = cMyID, int index = 0 )
{
    static int QSelect = -1;
    
    if ( QSelect == -1 )
    {
        QSelect = kbUnitQueryCreate( "Select" );
        kbUnitQuerySetState( QSelect, cUnitStateAlive );
        kbUnitQuerySetIgnoreKnockedOutUnits( QSelect, true );
    }
    
    if ( index == 0 )
    {
        kbUnitQueryResetResults( QSelect );
        kbUnitQuerySetUnitType( QSelect, unit );
        if ( owner >= 1000 )
        {
            kbUnitQuerySetPlayerID( QSelect, -1, false );
            kbUnitQuerySetPlayerRelation( QSelect, owner );
        }
        else
        {
            kbUnitQuerySetPlayerRelation( QSelect, -1 );
            kbUnitQuerySetPlayerID( QSelect, owner, false );
        }
        kbUnitQueryExecute( QSelect );
    }
    
    return( kbUnitQueryGetResult( QSelect, index ) );
}


int selectByZone( int unit = -1, int owner = cMyID, vector v = cInvalidVector, float r = 30.0, int index = 0 )
{
    static int QSelect = -1;
    
    if ( QSelect == -1 )
    {
        QSelect = kbUnitQueryCreate( "SelectZone" );
        kbUnitQuerySetState( QSelect, cUnitStateAlive );
        kbUnitQuerySetIgnoreKnockedOutUnits( QSelect, true );
        kbUnitQuerySetAscendingSort( QSelect, true );
    }
    
    if ( index == 0 )
    {
        kbUnitQueryResetResults( QSelect );
        kbUnitQuerySetUnitType( QSelect, unit );
        kbUnitQuerySetPosition( QSelect, v );
        kbUnitQuerySetMaximumDistance( QSelect, r );
        if ( owner >= 1000 )
        {
            kbUnitQuerySetPlayerID( QSelect, -1, false );
            kbUnitQuerySetPlayerRelation( QSelect, owner );
        }
        else
        {
            kbUnitQuerySetPlayerRelation( QSelect, -1 );
            kbUnitQuerySetPlayerID( QSelect, owner, false );
        }
        kbUnitQueryExecute( QSelect );
    }
    
    return( kbUnitQueryGetResult( QSelect, index ) );
}


void PLAY( int parm = -1 )
{
    kbLookAtAllUnitsOnMap();
    aiRandSetSeed( -1 );
    int youth = select( cUnitTypeAFRICANyouth );
    if ( youth == -1 )
        return;
    select( cUnitTypeHero, 0 );
    aiTaskUnitMove( youth, kbUnitGetPosition( select( cUnitTypeHero, 0, aiRandInt( numCivilizations ) ) ) );
    xsEnableRule("RPLAY");
}


rule RPLAY
inactive
minInterval 1
{
    if ( select( cUnitTypeAFRICANyouth ) >= 0 )
        return;
    xsDisableSelf();
    xsEnableRuleGroup( "RULES" );
}


rule ChooseEnemy
inactive
minInterval 1
runImmediately
group RULES
{
    if ( ( currentEnemy == -1 ) || ( kbHasPlayerLost( currentEnemy ) == true ) )
    {
        int player = 1 + aiRandInt( cNumberPlayers - 1 );
        for( enemy = player; < cNumberPlayers )
        {
            if ( ( kbHasPlayerLost( enemy ) == false ) && ( kbIsPlayerEnemy( enemy ) ) )
            {
                currentEnemy = enemy;
                break;
            }
        }
    }
}


rule ChooseUnits
inactive
minInterval 15
runImmediately
group RULES
{
    static int oldCoot = -1;
    if ( oldCoot == -1 )
        oldCoot = select( cUnitTypeIGCOldCoot );
    
    static int countUnits = -1;
    int unit = cUnitTypeLogicalTypeLandMilitary;
    if ( countUnits == -1 )
    {
        countUnits = kbUnitQueryCreate( "CountZone" );
        kbUnitQuerySetState( countUnits, cUnitStateAlive );
        kbUnitQuerySetIgnoreKnockedOutUnits( countUnits, true );
        
        kbUnitQuerySetUnitType( countUnits, unit );
        kbUnitQuerySetPosition( countUnits, kbUnitGetPosition( oldCoot ) );
        kbUnitQuerySetMaximumDistance( countUnits, 50.0 );
        kbUnitQuerySetPlayerRelation( countUnits, -1 );
        kbUnitQuerySetPlayerID( countUnits, 0, false );
    }
    
    kbUnitQueryResetResults( countUnits );
    int count = kbUnitQueryExecute( countUnits );
    
    selectByZone( unit, 0, kbUnitGetPosition( oldCoot ), 50.0 );
    aiTaskUnitMove( oldCoot, kbUnitGetPosition (selectByZone( unit, 0, kbUnitGetPosition( oldCoot ), 50.0, aiRandInt( count ) ) ) );
}


rule Attack
inactive
minInterval 2
group RULES
{
    vector v = kbUnitGetPosition( select( cUnitTypeBuilding, currentEnemy ) );
    if ( v == cInvalidVector ) v = kbUnitGetPosition( select( cUnitTypeUnit ) );
    
    if ( xsGetTime() < 60000 && aiNumberUnassignedUnits( cUnitTypeLogicalTypeLandMilitary ) <= 15 )
        return;
    if (aiNumberUnassignedUnits( cUnitTypeLogicalTypeLandMilitary ) <= 30)
        return;
    
    int attackPlan = aiPlanCreate("Attack",cPlanAttack);
    aiPlanSetDesiredPriority(attackPlan,75);
    aiPlanSetUnitStance(attackPlan,cUnitStanceAggressive);
    aiPlanSetAllowUnderAttackResponse(attackPlan,true);
    aiPlanSetVariableInt(attackPlan, cAttackPlanPlayerID, 0, currentEnemy);
    aiPlanSetVariableVector(attackPlan, cAttackPlanAttackPoint, 0, v);
    aiPlanSetVariableFloat(attackPlan, cAttackPlanAttackPointEngageRange, 0, 60.0);
    aiPlanSetNumberVariableValues(attackPlan,cAttackPlanTargetTypeID,3,true);
    aiPlanSetVariableInt(attackPlan, cAttackPlanTargetTypeID, 0, cUnitTypeUnit);
    aiPlanSetVariableInt(attackPlan, cAttackPlanTargetTypeID, 1, cUnitTypeSPCFortGate);
    aiPlanSetVariableInt(attackPlan, cAttackPlanTargetTypeID, 2, cUnitTypeBuilding);
    aiPlanSetVariableInt(attackPlan, cAttackPlanAttackRoutePattern, 0, cAttackPlanAttackRoutePatternBest);
    aiPlanSetVariableBool(attackPlan, cAttackPlanMoveAttack, 0, true);
    aiPlanSetVariableInt(attackPlan, cAttackPlanRefreshFrequency, 0, 5);
    aiPlanSetVariableInt(attackPlan, cAttackPlanHandleDamageFrequency, 0, 10);
    aiPlanSetVariableInt(attackPlan, cAttackPlanBaseAttackMode, 0, cAttackPlanBaseAttackModeRandom);
    aiPlanSetVariableInt(attackPlan, cAttackPlanRetreatMode, 0, cAttackPlanRetreatModeNone);
    aiPlanSetVariableInt(attackPlan, cAttackPlanGatherWaitTime, 0, 0);
    
    if (aiPlanGetNumber(cPlanAttack,-1, true) < 5)
    {
        aiPlanSetNoMoreUnits(attackPlan, true);
        for( i = 0; < 1000000 )
        {
            if (i>=3000) break;
            int unit = select(cUnitTypeUnit, cMyID, i);
            if (unit==-1) break;
            if ( kbUnitGetPlanID( unit ) >= 0 ) continue;
            if ( kbUnitIsType(unit, cUnitTypeHero)==true ) continue;
            aiPlanAddUnitType(attackPlan,kbUnitGetProtoUnitID(unit),0,0,aiNumberUnassignedUnits( kbUnitGetProtoUnitID(unit) ));
            aiPlanAddUnitType(attackPlan,cUnitTypeHero,0,0,0);
            aiPlanAddUnit(attackPlan, unit);
        }
    }
    else
    {
        aiPlanSetNoMoreUnits(attackPlan, false);
        for( i = 0; < 1000000 )
        {
            if (i>=3000) break;
            unit = select(cUnitTypeUnit, cMyID, i);
            if (unit==-1) break;
            if ( kbUnitGetPlanID( unit ) >= 0 ) continue;
            if ( kbUnitIsType(unit, cUnitTypeHero)==true ) continue;
            aiPlanAddUnitType(attackPlan,kbUnitGetProtoUnitID(unit),0,0,aiNumberUnassignedUnits( kbUnitGetProtoUnitID(unit) ));
            aiPlanAddUnitType(attackPlan,cUnitTypeHero,0,0,0);
        }
    }
    aiPlanSetActive(attackPlan,true);
}


rule Update
inactive
minInterval 10
group RULES
{
    vector v = kbUnitGetPosition( select( cUnitTypeAll, currentEnemy ) );
    for( i = 0; < aiPlanGetNumber( cPlanAttack, -1, true ) )
        aiPlanSetVariableVector( aiPlanGetIDByIndex( cPlanAttack, -1, true ), cAttackPlanAttackPoint, 0, v );
}

