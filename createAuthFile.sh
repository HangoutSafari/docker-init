#!/bin/sh

callFileText="export async function getCurrentSession(supabase, req) {
            const cookies = req.headers.cookie;
            const access_token = cookies.split('; ')[0].split('=')[1];

            const refresh_token = cookies.split('; ')[1].split('=')[1];
            const { sessionData, sessionError } = supabase.auth.setSession({
                access_token,
                refresh_token,
            })

            if (sessionError) {

                console.error('session error', sessionError);

                throw sessionError;

            }

            const {

                data: { user },

            } = await supabase.auth.getUser();
        return supabase;
}";

cd "backend";
echo -e "$callFileText" > getCurrentSession.js 
cd ..