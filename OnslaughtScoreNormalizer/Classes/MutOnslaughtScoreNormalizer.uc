//------------------------------------------------------------------------------
//  Created on: 2019-03-31
//  Makes it so that a victory in regular time and overtime in Onslaught are worth
//   the same amount of points, rather than giving 2 for regular time and 1 for overtime.
//
//  © 2019 by D. 'Crusha K. Rool' I.
//------------------------------------------------------------------------------
class MutOnslaughtScoreNormalizer extends Mutator;

event PostBeginPlay()
{
    local OnslaughtScoreNormalizerRules G;

    super.PostBeginPlay();
    G = spawn( class'OnslaughtScoreNormalizerRules' );
    // That's it. These GameRules take care of adding themselves in PostBeginPlay().
}

DefaultProperties
{
     GroupName="Onslaught"
     FriendlyName="Onslaught Score Normalizer"
     Description="Changes scoring in Onslaught so that a victory within regular time and overtime are both worth 1 point."
}