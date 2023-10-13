import React, { useEffect } from "react";
import { TCommit, TIntent } from "../types";

// MUI
import Box from '@mui/material/Box';
import Button from '@mui/material/Button';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import ListItemText from '@mui/material/ListItemText';
import { ListItemButton } from "@mui/material";

export const Intents = ({ intents, vendor, intent, commits, commit }: {
    intents: Array<TIntent>;
    vendor: boolean;
    intent: () => void;
    commits: Array<TCommit>;
    commit: () => void;
}) => {

    if (vendor) {
        if (intents.length === 0) {
            return (
                <Box>
                    No one has shown intent for this advert yet 
                </Box>
            )
        } else {
            return (
                <List>
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

            )
        }
    }  else {
        return (
            <Button variant="contained" disabled={intents.length !== 0} onClick={intent} sx={{ m:2 }}>
                Express Intent to Buy
            </Button>
        )
    }

}