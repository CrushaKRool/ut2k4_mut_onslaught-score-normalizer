//==============================================================================
//  Created on: 2019-03-31
//  Makes it so that a victory in regular time and overtime in Onslaught are worth
//   the same amount of points, rather than giving 2 for regular time and 1 for overtime.
//
//  © 2019 by D. 'Crusha K. Rool' I.
//==============================================================================
class OnslaughtScoreNormalizerRules extends GameRules;

// How many more points does a regular win give us compared to overtime?
const ScoreDiff = 1;

event PostBeginPlay()
{
    if ( ONSOnslaughtGame( Level.Game ) == none )
    {
        Destroy();
    }
    Level.Game.AddGameModifier( self );
}

/* CheckScore()
This is called after an objective in ONS is destroyed.
Scorer is the last player who damaged the objective.
Since we don't want a regular win (outside of overtime) to count as two points,
we simply subtract one point from the corresponding team's score if the victory was not in overtime.
*/
function bool CheckScore(PlayerReplicationInfo Scorer)
{
    local ONSOnslaughtGame onsGame;

    onsGame = ONSOnslaughtGame( Level.Game );
    // We don't handle overtime cases, since there is no need to normalize
    // and some annoying edge cases exist, like Core Drain with no real damage during the entire match.
    // That would leave us with Scorer == none.
    if ( onsGame != none && !onsGame.bOverTime && !onsGame.bGameEnded )
    {
        if ( Scorer == none )
        {
            // Since there is no Scorer, we have to check both teams individually.
            // This *should* never happen during normal ONS, but let's try our best just in case.
            if ( IsEnemyMainCoreDestroyed( onsGame, 0 ) && !IsEnemyMainCoreDestroyed( onsGame, 1 ) )
            {
                onsGame.Teams[ 0 ].Score -= ScoreDiff;
            }
            if ( IsEnemyMainCoreDestroyed( onsGame, 1 ) && !IsEnemyMainCoreDestroyed( onsGame, 0 ) )
            {
                onsGame.Teams[ 1 ].Score -= ScoreDiff;
            }
        }
        else
        {
            // Only need to check the team of the player who scored the objective.
            if ( IsEnemyMainCoreDestroyed( onsGame, Scorer.Team.TeamIndex ) )
            {
                onsGame.Teams[ Scorer.Team.TeamIndex ].Score -= ScoreDiff;
            }
        }
    }

	if ( NextGameRules != none )
	{
		return NextGameRules.CheckScore( Scorer );
    }
	return false;
}

function bool IsEnemyMainCoreDestroyed( ONSOnslaughtGame OnsGame, int OwnTeamIndex )
{
    local ONSPowerCore enemyCore;
    enemyCore = OnsGame.PowerCores[ OnsGame.FinalCore[ Abs( OwnTeamIndex - 1 ) ] ];
    return enemyCore.Health <= 0;
}

DefaultProperties
{

}