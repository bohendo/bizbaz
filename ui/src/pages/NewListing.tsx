import React, {useEffect, useState} from "react";

// MUI Components
import TextField from '@mui/material/TextField';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogContentText from '@mui/material/DialogContentText';
import DialogTitle from '@mui/material/DialogTitle';
import Button from "@mui/material/Button";

import { NewListing, ListingValidation  } from "../types";

export const NewListing = ({
    open,
    handleCloseDialog,
    api
}: {
    open: boolean;
    handleCloseDialog: () => void;
    // TODO: Fix api type
    api: any
}) => {
    const [validation, setValidation] = useState({
        hasError: false,
        errorMsgs: {
            descriptionError: "",
            tagsError: ""
        }
    } as ListingValidation)
    const [newListing, setNewListing] = useState({
        description: "",
        tags: []
    } as NewListing);

    const validate = (listing: NewListing) => {
       const descriptionError = !listing.description ? "Listing description is required" : "";
       const tagsError = ""
       const hasError = !!(descriptionError || tagsError);
       setValidation({ hasError, errorMsgs: {descriptionError, tagsError}});
    }
    const syncNewListing = (listing: NewListing) => {
       validate(listing);
       setNewListing(listing);
    }

    const postListing = () => {
        validate(newListing);
        if (validation.hasError) return;
        api.poke({
          app: 'bizbaz',
          mark: 'listing-action',
          json: { 
            'create': { 
              listing: {
                who: `~${window.ship}`,
                tags: ["tag1", "tag2"],
                description: newListing.description,
                when: Math.floor((new Date()).getTime() / 1000)
              }
            }
          }
        })
    
    }

    return (
        <Dialog open={open} onClose={handleCloseDialog}>
            <DialogContent>
               <DialogContentText>
                  Create New Listing
               </DialogContentText>
               <TextField
                    autoFocus
                    error={!!validation.errorMsgs.descriptionError}
                    margin="dense"
                    id="description"
                    label="Description"
                    type="text"
                    fullWidth
                    variant="standard"
                    onChange={(event) => {
                        console.log(event);
                        syncNewListing({...newListing, [event.target.id]: event.target.value})}
                    }
                />
            </DialogContent>
            <DialogActions>
                <Button variant="contained" onClick={postListing}>
                    Submit
                </Button>
            </DialogActions>
        </Dialog>
    )
}