
////////////////////////////////////////
// Signatures

export type Signature = {
    life: string;
    ship: string;
    sig: string;
};

////////////////////////////////////////
// Adverts

export type AdvertReq = {
    title: string;
    cover: string;
    tags: Array<string>;
    description: string;
}

export type AdvertBody = {
    cover: string;
    description: string;
    tags: Array<string>;
    title: string;
    when: number;
}

export type Advert = {
    hash: string;
    body: AdvertBody;
    vendor: Signature;
}

export type AdvertUpdate = {
    hash: string;
    body: AdvertReq;
}

export type AdvertValidation = {
    hasError: boolean;
    errorMsgs: {
        coverError: string;
        descriptionError: string;
        tagsError: string;
        titleError: string;
    }
}

////////////////////////////////////////
// Votes

export type Vote = {
    hash: string;
    body: {
        advert: string;
        choice: string;
        voter: string;
        when: number;
    };
    voter: Signature;
}

////////////////////////////////////////
// Reviews

export type IntentBody = {
    advert: string;
    vendor: Signature;
    client: string;
    when: number;
}

export type Intent = {
    hash: string;
    client: Signature;
    body: IntentBody;
};

export type CommitBody = {
    intent: string;
    client: Signature;
    vendor: string;
    when: number;
}

export type Commit = {
    hash: string;
    vendor: Signature;
    body: CommitBody;
    intent: IntentBody;
};

export type ReviewBody = {
    commit: string;
    reviewee: string;
    score: number;
    why: string;
    when: number;
}

export type Review = {
    hash: string;
    reviewer: Signature;
    body: ReviewBody;
    commit: Commit;
};
