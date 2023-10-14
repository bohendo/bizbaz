import React, { useEffect } from "react";

// MUI
import Card from '@mui/material/Card';
import CardHeader from '@mui/material/CardHeader';
import CardActions from '@mui/material/CardActions';
import { TIntent } from "../types";
import Button from '@mui/material/Button';
import IconButton from '@mui/material/IconButton';

// Icons
import BackHandIcon from '@mui/icons-material/BackHand';
import CommitIcon from '@mui/icons-material/Commit';

export const IntentCard = ({intent, intentAction, commitAction, vendor}: {
    intent: TIntent | undefined;
    intentAction: () => void;
    commitAction: () => void;
    vendor: string;
}) => {
    return (
        <Card variant="outlined">
            <CardHeader title={vendor === `~${window.ship}` ?
                `${intent?.client.ship} has shown interest`
                :intent ? `${vendor} has been notified about your interest in the advert `
                        :`Express Intent in advert`
            }/>

            <CardActions>
                {vendor === `~${window.ship}` ? 
                    <Button onClick={commitAction}>
                        Commit
                    </Button>
                :!intent ?
                    <IconButton onClick={intentAction}>
                        <BackHandIcon />
                    </IconButton>
                    :null
            }
            </CardActions>
        </Card>
    )
}