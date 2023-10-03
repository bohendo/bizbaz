import React from 'react';

// MUI
import { useTheme } from "@mui/material/styles"

export const Profile = ({ api }: { api: any }) => {
    const theme = useTheme();
    return (
        <div style={{marginTop: theme.spacing(8)}}>
            Profile
        </div>
    )
}