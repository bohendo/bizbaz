export type TListingValidation = {
    hasError: boolean;
    errorMsgs: {
        titleError: string;
        descriptionError: string;
        tagsError: string;
    }
}

export type TNewListing = {
    title: string;
    description: string;
    tags: Array<string>;
}

export type TListing = {
    title: string;
    description: string;
    tags: Array<string>;
    when: number;
    who: string;
}