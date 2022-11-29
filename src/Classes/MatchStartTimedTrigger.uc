class MatchStartTimedTrigger extends TimedTrigger;

function PostBeginPlay()
{
    // Log("MatchStartTimedTrigger.PostBeginPlay => Level.Game.IsA('DeathMatchPlus')="$Level.Game.IsA('DeathMatchPlus')$", DeathMatchPlus(Level.Game).bRequireReady="$DeathMatchPlus(Level.Game).bRequireReady, 'GameEvents');
}

function Trigger(Actor Other, Pawn EventInstigator)
{
    Log("MatchStartTimedTrigger.Trigger => StartMatch(Other.Name="$Other.Name$", EventInstigator.Name="$EventInstigator.Name$")", 'GameEvents');
    GameEventsManager(Owner).StartMatch();
}

defaultproperties {
    Event=MatchStart
}