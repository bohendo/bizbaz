import React, {useEffect, useState} from "react";

// MUI Components
import TextField from '@mui/material/TextField';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogContentText from '@mui/material/DialogContentText';
import DialogTitle from '@mui/material/DialogTitle';
import Button from "@mui/material/Button";


export const NewListing = ({
    open,
    handleCloseDialog,
    api
}: {
    open: boolean;
    handleCloseDialog: () => void;
    api: any
}) => {

    const postListing = () => {
        console.log("Creating new listing");
        api.poke( {
          app: 'bizbaz',
          mark: 'listing-action',
          json: { 
            'create': { 
              listing: {
                who: `~${window.ship}`,
                tags: ["tag1", "tag2"],
                description: "test listing",
                when: 1630471524
              }
            }
          }
        } )
    
    }

    return (
        <Dialog open={open} onClose={handleCloseDialog}>
            <DialogContent>
               <DialogContentText>
                  Create New Listing
               </DialogContentText>
               <TextField
                    autoFocus
                    margin="dense"
                    id="description"
                    label="Description"
                    type="text"
                    fullWidth
                    variant="standard"
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