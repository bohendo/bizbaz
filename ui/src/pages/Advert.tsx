import React, { useContext, useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';

import { BizbazContext } from "../BizbazContext"

// Components
import { Votes } from '../components/Votes';
import { Intents } from '../components/Intents';
import { CommitCard } from "../components/CommitCard";
import { ReviewCard } from "../components/ReviewCard";
import { NewAdvert } from "../components/NewAdvert";
import { NewReview } from "../components/NewReview";

// MUI
import Button from '@mui/material/Button';
import CircularProgress from '@mui/material/CircularProgress';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import Fab from '@mui/material/Fab'
import Paper from "@mui/material/Paper";
import Typography from '@mui/material/Typography';
import { useTheme } from "@mui/material/styles"

import { TAdvert, TCommit, TIntent, TReview, TVote } from "../types";


// Icons
import EditIcon from '@mui/icons-material/Edit';

export const Advert = ({ api }: { api: any }) => {
  const bizbaz = useContext(BizbazContext);
  const theme = useTheme();
  const { hash } = useParams();
  const navigate = useNavigate();
  const [advert, setAdvert] = useState({} as TAdvert);

  const [reviewCommit, setReviewCommit] = useState<TCommit | undefined>(undefined);
  const [ourVote, setOurVote] = useState({} as TVote);
  const [openNewAdvertDialog, setOpenNewAdvertDialog] = useState(false);
  const [openNewReviewDialog, setOpenNewReviewDialog] = useState(false);

  const { adverts, votes, intents, commits, reviews } = bizbaz;

  console.log(`Got bizbaz context:`, bizbaz)

  useEffect(() => {
    setAdvert(adverts.find((a: TAdvert) => a.hash === hash) || {} as TAdvert);
  }, [adverts]);

  const updateAdvert = ( upd: any) => {
    if (upd.update) {
      navigate(`advert/${upd.update.update.new.hash}`)
    }
  }

  useEffect(() => {
    async function init() {
      api.subscribe( { app: "bizbaz", path: '/json/adverts', event: updateAdvert } )
    }
    init();
  }, []);

  const vote = (choice: string) => {
      api.poke({
        app: 'bizbaz',
        mark: 'vote-action',
        json: { 
          'vote': { 
            advert: hash,
            choice: choice
          }
        }
      })
  }

  const intent = () => {
      api.poke({
        app: 'bizbaz',
        mark: 'review-action',
        json: { 
          'intent': { 
            advert: hash
          }
        }
      })
  }

  const commit = () => {
      const intent = intents[0]?.hash
      if (!intent) {
          console.log(`No intent exists to commit to`)
          return
      }
      console.log(`Committing to intent ${intent}`)
      api.poke({
        app: 'bizbaz',
        mark: 'review-action',
        json: { 
          'commit': { intent }
        }
      })
  }

  const doReview = (commit: TCommit) => {
    setReviewCommit(commit)
    setOpenNewReviewDialog(true)
  }

  if (advert === undefined) {
    // TODO: create error 404 not found page
    return <div> Advert does not exist </div>
  } else if (advert.body) {
    return (
      <div>
        <Paper variant="outlined" sx={{ p: 8, m: 8 }}>
          <Typography variant="h2">
            {advert.body.title}
          </Typography>
          <Typography variant="caption">
            Posted by: {advert.vendor.ship}
          </Typography>
          <Typography variant="h5">
            Tags: {advert.body.tags?.join(", ")}
          </Typography>
          <Typography variant="body1">
            Description: {advert.body.description}
          </Typography>

          <Votes votes={votes} vote={vote} />

        </Paper>

        <Intents intents={intents} intentAction={intent}
          vendor={advert.vendor.ship}
          commitAction={commit}
        />

        <List>
            {commits.map((commit: TCommit, i) => {
                return(
                    <ListItem key={i}>
                      <CommitCard
                          commit={commit}
                          doReview={() => doReview(commit)}
                      />
                    </ListItem>
                )
            })}
        </List>

        <List>
            {reviews.map((review: TReview, i) => {
                return(
                    <ListItem key={i}>
                      <ReviewCard review={review} />
                    </ListItem>
                )
            })}
        </List>

        <Fab color='primary' sx={{
          position: 'fixed',
          right: theme.spacing(4),
          bottom: theme.spacing(3)
        }} onClick={() => setOpenNewAdvertDialog(true)}>
          <EditIcon />
        </Fab>

        <NewAdvert
          editAdvert={{
            hash: advert.hash,
            body: {
              title: advert.body.title,
              tags: advert.body.tags,
              description: advert.body.description,
              cover: advert.body.cover,
              when: Date.now()
            }
          }}
          edit={true}
          open={openNewAdvertDialog} handleCloseDialog={() => setOpenNewAdvertDialog(false)}
          api={api}
        /> 

        <NewReview
          commit={reviewCommit}
          open={openNewReviewDialog}
          handleCloseDialog={() => setOpenNewReviewDialog(false)}
          api={api}
        />

    </div>
  )} else return (
    <CircularProgress color="inherit" sx={{margin: theme.spacing(16)}} />
  )
}
