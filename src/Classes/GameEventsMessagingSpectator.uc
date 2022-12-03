class GameEventsMessagingSpectator extends MessagingSpectator;

event ReceiveLocalizedMessage(class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	local CTFFlag CTFFlag;

    if (Message == class'CTFMessage')
	{
        CTFFlag = CTFFlag(OptionalObject);
		if (CTFFlag != None)
        {
			switch(Switch)
			{
				case 0:
                    // CTFFlag.Team => 0:scored the red flag, 1:scored the blue flag
                    GameEventsManager(Owner).FlagCapture(RelatedPRI_1, CTFFlag);
            }
        }
    }
}

defaultproperties {
    bHidden=True
}