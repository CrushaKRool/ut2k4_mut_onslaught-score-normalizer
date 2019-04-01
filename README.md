This Mutator changes scoring rules in Onslaught so that a victory in regular time and overtime are both worth 1 point, rather than giving 2 for a victory in regular time and 1 for overtime.

# Usage
You can simply activate it like any other Mutator through the game UI.

If you are a server administrator and don't want your server to become non-standard from using a Mutator that is not on the whitelist, you may also simple add this as a ServerActor:

    [Engine.GameEngine]
    ...
    ServerActors=OnslaughtScoreNormalizer.OnslaughtScoreNormalizerRules

OnslaughtScoreNormalizer is the name of this code's package/compiled .u file.

# Implementation note
The game does not really offer a hook to change the actual scoring rules without creating a new gametype, so this implementation uses a little hack instead:

It uses the `GameRules.CheckScore()` hook that is checked every time an objective is scored, which is meant to let mods prevent the game from ending at that point. Inside this hook will it reduce the scoring team's score by 1 if its not overtime (yes, we deliberately create side effects in a function that is only meant to be called for its return value). This winning scenario would have given the team 2 points in a normal match.

Since we don't know if the hook got called from destroying the final core or just a regular node and we only want to subtract the score once at the very end of a match, we check the remaining HP on the cores at that point and deduce from that whether the match ended.

This should not be any issue in any normal match scenario. But since it's a slight hack, I can't make any guarantees about how it might work in conjunction with other mods that do something in this area.
