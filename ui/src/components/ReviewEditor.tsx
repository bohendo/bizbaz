import React, {useEffect, useState} from "react";

// MUI Components
import Button from "@mui/material/Button";
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogContentText from '@mui/material/DialogContentText';
import DialogTitle from '@mui/material/DialogTitle';
import Rating from '@mui/material/Rating';
import TextField from '@mui/material/TextField';

const myShip = `~${window.ship}`

export const ReviewEditor = ({
  commit,
  oldReview,
  open,
  handleCloseDialog,
  api,
}: {
  commit: any;
  oldReview?: TReview | undefined;
  open: boolean;
  handleCloseDialog: () => void;
  api: any // TODO: Fix api type
}) => {
  const [newReview, setNewReview] = useState({
    score: 3,
    why: "",
  } as any);

  useEffect(() => {
    if (oldReview) {
      console.log(`Editing old review:`, oldReview)
      setNewReview({ score: oldReview.body.score, why: oldReview.body.why })
    }
  }, [oldReview]);

  const reviewee = commit?.vendor?.ship === myShip ? commit?.body?.client?.ship : commit?.vendor?.ship;

  const syncNewReview = (review: any) => {
   setNewReview(review);
  }

  const postReview = () => {
    console.log(`Posting new review:`, newReview);
    api.poke({
      app: 'bizbaz',
      mark: 'review-action',
      json: { 
        'review': { 
          commit: commit.hash,
          score: newReview.score,
          why: newReview.why,
        }
      }
    })
    handleCloseDialog()
  }

  return (
    <Dialog open={open} onClose={handleCloseDialog}>
      <DialogContent>
       <DialogContentText>
          Review {reviewee}
       </DialogContentText>
       <Rating
         id="score"
         defaultValue={newReview.score}
         size="large"
         onChange={(event, score) => {
             syncNewReview({...newReview, score})}
         }
       />
       <TextField
         id="why"
         defaultValue={newReview.why}
         margin="dense"
         label="Why?"
         type="text"
         fullWidth
         helperText={"Describe why you gave this score"}
         variant="standard"
         onChange={(event) => {
             syncNewReview({...newReview, [event.target.id]: event.target.value})}
         }
       />

      </DialogContent>
      <DialogActions>
        <Button variant="contained" onClick={postReview} disabled={!commit}>
          Submit
        </Button>
      </DialogActions>
    </Dialog>
  )
}
