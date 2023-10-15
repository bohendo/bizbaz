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

export const IntentCard = ({intent, commitAction}: {
    intent: TIntent | undefined;
    commitAction: () => void;
}) => {
    const myShip = `~${window.ship}`
    const vendor = intent ? intent?.body?.vendor?.ship : "..."
    const client = intent ? intent?.client?.ship : "..."
    return (
        <Card variant="outlined" sx={{ p: 2, mt: 2 }}>
            <CardHeader title={vendor === myShip ?
                `${client} has shown interest`
                : `${vendor} has been notified about your interest in the advert `
            }/>

            {(vendor === `~${window.ship}`) ? (
              <CardActions>
                  <Button onClick={commitAction}>
                      Commit
                  </Button>
              </CardActions>
            ) : null}

        </Card>
    )
}
