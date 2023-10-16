import React, { useEffect } from "react";
import { TCommit, TIntent } from "../types";

// MUI
import Box from '@mui/material/Box';
import Button from '@mui/material/Button';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import ListItemText from '@mui/material/ListItemText';
import Paper from "@mui/material/Paper";
import Typography from '@mui/material/Typography';
import { IntentCard } from "./IntentCard";

export const Intents = ({ intents, vendor, intentAction, commitAction }: {
    intents: Array<TIntent>;
    vendor: string;
    intentAction: () => void;
    commitAction: () => void;
}) => {

    if(vendor  === `~${window.ship}`) {
        if(intents.length > 0)
            return (
                <List>
                    {intents.map((intent: TIntent, i) => {
                      return(
                          <ListItem key={i}>
                              <IntentCard intent={intent} intentAction={intentAction} commitAction={commitAction} vendor={vendor} />
                          </ListItem>
                      )
                    })}
                </List>
            )
        else return (
            <Paper> No one has shown intent for this advert yet </Paper>
        )

        } else {
            return (
                <Paper variant="outlined" sx={{ p: 8, m: 8 }}>
                    <IntentCard intent={intents.find(
                        (intent: TIntent) => intent.client.ship === `~${window.ship}`)}
                    intentAction={intentAction} commitAction={commitAction} vendor={vendor} />
                </Paper>
            )

        }
    }