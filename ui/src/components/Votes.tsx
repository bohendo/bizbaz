import React, { useEffect, useState } from "react";

// MUI
import Avatar from '@mui/material/Avatar';
import Box from '@mui/material/Box';
import Button from '@mui/material/Button';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogContentText from '@mui/material/DialogContentText';
import IconButton from '@mui/material/IconButton';
import { useTheme } from "@mui/material/styles"

// Icons
import ArrowDropUpIcon from '@mui/icons-material/ArrowDropUp';
import ArrowDropDownIcon from '@mui/icons-material/ArrowDropDown';
import NotInterestedIcon from '@mui/icons-material/NotInterested';

import { TVote } from "../types";

export const Votes = ({
    votes,
    vote,
    disabled,
}: {
    votes: Array<TVote>;
    vote: (choice: string) => void;
    disabled: boolean;
}) => {
    const theme = useTheme();
    const [ourVote, setOurVote] = useState<TVote | undefined>(undefined);
    const [open, setOpen] = useState(false);
    const [voteScore, setVoteScore] = useState(0);

    useEffect(() => {
        if (votes.length > 0) {
          setOurVote(votes.find((v: TVote) => v.voter.ship === `~${window.ship}`))
          setVoteScore(votes.reduce((score, vote) => vote.body.choice === "up" ? score + 1 : score - 1, 0));
        }
    }, [votes])

    return (
        <Box display='flex' flexDirection='column' maxWidth={50}>
          <IconButton sx={{ m: theme.spacing(-2)}}
            color={ourVote?.body?.choice === "up" ? 'primary' : 'default'}
            onClick={() => vote(ourVote?.body?.choice === "up" ? "un" : "up")}
            disabled={disabled}
          >
            <ArrowDropUpIcon sx={{ fontSize: 60 }} />
          </IconButton>
          <Avatar sx={{ width: 24, height: 24, m: 1.5 }}>
            {voteScore}
          </Avatar>
          <IconButton sx={{ m: theme.spacing(-2)}}
            color={ourVote?.body?.choice === "down" ? 'primary' : 'default'}
            onClick={() => setOpen(true)}
            disabled={disabled}
          >
            <ArrowDropDownIcon sx={{ fontSize: 60 }} />
          </IconButton>
          <Dialog open={open} onClose={() => setOpen(false)}>
            <DialogContent>
              <DialogContentText>
                Are you sure you want to <b> Down Vote </b>?
                This is an irreversible action, which will delete the 
                advert from your ship and report it to your pals.
              </DialogContentText>
              <DialogActions>
                <Button variant="contained" onClick={() => { vote("down"); setOpen(false)}}>
                  Yes, I'm sure! Delete & report the ad
                </Button>
                <Button variant="contained" onClick={() => setOpen(false)}>
                  Cancel
                </Button>
              </DialogActions>
            </DialogContent>
          </Dialog>
        </Box>
    )
}
