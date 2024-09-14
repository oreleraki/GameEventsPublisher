class MatchStartTimedTrigger extends TimedTrigger;

function PostBeginPlay()
{
    // Log("MatchStartTimedTrigger.PostBeginPlay => Level.Game.IsA('DeathMatchPlus')="$Level.Game.IsA('DeathMatchPlus')$", DeathMatchPlus(Level.Game).bRequireReady="$DeathMatchPlus(Level.Game).bRequireReady, 'GameEventsPublisher');
}

function Trigger(Actor Other, Pawn EventInstigator)
{
    local string instigatorName;
    if (EventInstigator != None)
    {
        instigatorName = EventInstigator.GetHumanName();
    }
    Log("MatchStartTimedTrigger.Trigger => StartMatch(Other.Name="$Other.Name$", EventInstigator.Name="$instigatorName$")", 'GameEventsPublisher');
    GameEventsManager(Owner).StartMatch();
}

defaultproperties {
    Event=MatchStart
}