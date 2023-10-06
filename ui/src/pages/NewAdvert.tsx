import React, {useEffect, useState} from "react";

// MUI Components
import TextField from '@mui/material/TextField';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogContentText from '@mui/material/DialogContentText';
import DialogTitle from '@mui/material/DialogTitle';
import Button from "@mui/material/Button";

import { TNewAdvert, TAdvertValidation  } from "../types";

export const NewAdvert = ({
    editAdvert,
    edit,
    open,
    handleCloseDialog,
    api
}: {
    editAdvert?: TNewAdvert;
    edit?: boolean;
    open: boolean;
    handleCloseDialog: () => void;
    // TODO: Fix api type
    api: any
}) => {
    const [validation, setValidation] = useState({
        hasError: false,
        errorMsgs: {
            titleError: "",
            coverError: "",
            descriptionError: "",
            tagsError: ""
        }
    } as TAdvertValidation)
    const [newAdvert, setNewAdvert] = useState(editAdvert || {
        title: "Advert Title",
        cover: "link to cover image",
        description: "Description of the stuff I'm selling",
        tags: ["example"]
    } as TNewAdvert);

    useEffect(() => {
        if (editAdvert)
            setNewAdvert(editAdvert);
    }, [editAdvert]);

    const validate = (advert: TNewAdvert) => {
       const titleError = !advert.title ? "Advert must have a title" : "";
       const coverError = !advert.cover ? "Advert cover must be a url" : "";
       const descriptionError = !advert.description ? "Advert description is required" : "";
       let tagsError = advert.tags.reduce((tagError, tag) =>
            /^[a-z][a-z0-9-]*$/.test(tag) ? tagError : tagError + ` '${tag}'`,
            "");
    
        if (tagsError) 
            tagsError = "Tags must start with an alphabet and only contain alphanumeric and '-' symbols. \
                         Following are invalid tags: "
                        + tagsError;
       const hasError = !!(descriptionError || tagsError);
       setValidation({ hasError, errorMsgs: {coverError, titleError, descriptionError, tagsError}});
    }
    const syncNewAdvert = (advert: TNewAdvert) => {
       validate(advert);
       setNewAdvert(advert);
    }

    const postAdvert = () => {
        validate(newAdvert);
        if (validation.hasError) return;
        const body = {
          title: newAdvert.title,
          cover: newAdvert.cover,
          tags: newAdvert.tags,
          description: newAdvert.description,
          when: Date.now(),
        };

        if (edit) {
            const req = {
                'update': {
                    hash: newAdvert.hash,
                    ...body,
                }
            }
            console.log(req);
            api.poke({
                app: 'bizbaz',
                mark: 'advert-action',
                json: req,
            })
        } else {
            const req = {
                'create': body
            }
            console.log(req);
            api.poke({
            app: 'bizbaz',
            mark: 'advert-action',
            json: req,
          })
        }
        handleCloseDialog()
    }

    return (
        <Dialog open={open} onClose={handleCloseDialog}>
            <DialogContent>
               <DialogContentText>
                  {edit ? 
                    <>Edit Advert {newAdvert.hash}</>
                    : <> Create New Advert </>
                  }
               </DialogContentText>
               <TextField
                 autoFocus
                 defaultValue={newAdvert.title}
                 error={!!validation.errorMsgs.titleError}
                 margin="dense"
                 id="title"
                 label="Title"
                 type="text"
                 fullWidth
                 helperText={validation.errorMsgs.titleError}
                 variant="standard"
                 onChange={(event) => {
                     syncNewAdvert({...newAdvert, [event.target.id]: event.target.value})}
                 }
               />
               <TextField
                 error={!!validation.errorMsgs.coverError}
                 defaultValue={newAdvert.cover}
                 margin="dense"
                 id="cover"
                 label="Cover"
                 type="text"
                 fullWidth
                 helperText={validation.errorMsgs.coverError}
                 variant="standard"
                 onChange={(event) => {
                     syncNewAdvert({...newAdvert, [event.target.id]: event.target.value})}
                 }
               />
                <TextField
                 error={!!validation.errorMsgs.tagsError}
                 defaultValue={newAdvert.tags}
                 margin="dense"
                 id="tags"
                 label="Tags"
                 type="text"
                 fullWidth
                 helperText={validation.errorMsgs.tagsError}
                 variant="standard"
                 onChange={(event) => {
                     syncNewAdvert({...newAdvert, [event.target.id]: event.target.value.toLowerCase().trim().split(" ")})}
                 }
                />
               <TextField
                 error={!!validation.errorMsgs.descriptionError}
                 defaultValue={newAdvert.description}
                 margin="dense"
                 id="description"
                 label="Description"
                 type="text"
                 fullWidth
                 helperText={validation.errorMsgs.descriptionError}
                 variant="standard"
                 onChange={(event) => {
                     syncNewAdvert({...newAdvert, [event.target.id]: event.target.value})}
                 }
                />

            </DialogContent>
            <DialogActions>
                <Button variant="contained" onClick={postAdvert}>
                    Submit
                </Button>
            </DialogActions>
        </Dialog>
    )
}
