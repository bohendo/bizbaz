import React, { useEffect, useState } from "react";

// MUI
import Avatar from '@mui/material/Avatar';
import Box from '@mui/material/Box';
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

}: {
    votes: Array<TVote>;
    vote: (choice: string) => void;
}) => {
    const theme = useTheme();
    const [ourVote, setOurVote] = useState<TVote | undefined>(undefined);
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
              onClick={() => vote(ourVote?.body?.choice === "up" ? "un" : "up")}>
                <ArrowDropUpIcon sx={{ fontSize: 60 }} />
            </IconButton>
            <Avatar sx={{ width: 24, height: 24, m: 1.5 }}>
                {voteScore}
            </Avatar>
            <IconButton sx={{ m: theme.spacing(-2)}}
              color={ourVote?.body?.choice === "down" ? 'primary' : 'default'}
              onClick={() => vote(ourVote?.body?.choice === "down" ? "un" : "down")}>
                <ArrowDropDownIcon sx={{ fontSize: 60 }} />
            </IconButton>
        </Box>
    )
}