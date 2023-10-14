import React, { useEffect } from "react";
import { TCommit, TIntent } from "../types";

// MUI
import Box from '@mui/material/Box';
import Button from '@mui/material/Button';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import ListItemText from '@mui/material/ListItemText';
import { ListItemButton } from "@mui/material";
import Paper from "@mui/material/Paper";
import Typography from '@mui/material/Typography';

export const Intents = ({ intents, vendor, intent, commits, commit }: {
    intents: Array<TIntent>;
    vendor: string;
    intent: () => void;
    commits: Array<TCommit>;
    commit: () => void;
}) => {

    return (
        <Paper variant="outlined" sx={{ p: 8, m: 8 }}>
            {vendor  === `~${window.ship}` ? 
                intents.length === 0 ?
                <> No one has shown intent for this advert yet </>
                :   <List>
                    {intents.map((intent: TIntent, i) => {
                        console.log(intent);
                        return(
                            <ListItem key={i} secondaryAction={
                                <Button variant="contained" disabled={intents.length === 0 || commits.length !== 0} onClick={commit} sx={{ m:2 }}>
                                    Commit to Sell
                                </Button>

                            }>
                                <ListItemText primary={`${intent.client.ship} has shown interest.`} />
                            </ListItem>
                        )
                    })}

                </List>
            :   intents.filter((intent: TIntent) => intent.client.ship === `~${window.ship}`).length === 0 ?
                <Button variant="contained" onClick={intent} sx={{ m:2 }}>
                    Express Intent to Buy
                </Button>
                :   <Typography variant="body1"> {vendor} has been notified about your interest in the advert </Typography>
            }

        </Paper>
    );
}